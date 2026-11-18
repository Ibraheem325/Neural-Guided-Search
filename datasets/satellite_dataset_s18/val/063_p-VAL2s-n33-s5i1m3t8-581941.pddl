(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	spectrograph1 - mode
	infrared2 - mode
	image0 - mode
	Star1 - direction
	Star3 - direction
	GroundStation7 - direction
	Star0 - direction
	Star6 - direction
	GroundStation5 - direction
	GroundStation4 - direction
	GroundStation2 - direction
	Planet8 - direction
	Phenomenon9 - direction
	Phenomenon10 - direction
	Phenomenon11 - direction
	Star12 - direction
	Phenomenon13 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Planet17 - direction
	Planet18 - direction
	Star19 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon15)
	(supports instrument1 spectrograph1)
	(supports instrument1 infrared2)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 GroundStation4)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation2)
	(supports instrument2 image0)
	(supports instrument2 infrared2)
	(supports instrument2 spectrograph1)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star6)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet8)
	(supports instrument3 spectrograph1)
	(supports instrument3 image0)
	(supports instrument3 infrared2)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 Star6)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet8)
	(supports instrument4 infrared2)
	(calibration_target instrument4 GroundStation2)
	(calibration_target instrument4 GroundStation4)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Phenomenon11)
)
(:goal (and
	(pointing satellite0 Phenomenon9)
	(pointing satellite1 Star12)
	(pointing satellite2 Phenomenon9)
	(pointing satellite3 Phenomenon10)
	(pointing satellite4 Planet8)
	(have_image Planet8 infrared2)
	(have_image Phenomenon9 infrared2)
	(have_image Phenomenon10 spectrograph1)
	(have_image Phenomenon11 image0)
	(have_image Star12 spectrograph1)
	(have_image Phenomenon13 infrared2)
	(have_image Planet14 image0)
	(have_image Phenomenon15 spectrograph1)
	(have_image Planet16 infrared2)
	(have_image Planet17 spectrograph1)
	(have_image Planet18 spectrograph1)
	(have_image Star19 infrared2)
))

)
