(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	instrument3 - instrument
	satellite3 - satellite
	instrument4 - instrument
	image3 - mode
	spectrograph2 - mode
	thermograph4 - mode
	infrared1 - mode
	spectrograph0 - mode
	GroundStation0 - direction
	Star1 - direction
	Phenomenon2 - direction
	Star3 - direction
	Star4 - direction
	Phenomenon5 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon5)
	(supports instrument1 infrared1)
	(supports instrument1 spectrograph2)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 Star1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon5)
	(supports instrument2 thermograph4)
	(supports instrument2 spectrograph0)
	(supports instrument2 image3)
	(calibration_target instrument2 Star1)
	(supports instrument3 infrared1)
	(supports instrument3 spectrograph2)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 Star1)
	(on_board instrument2 satellite2)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon2)
	(supports instrument4 spectrograph0)
	(supports instrument4 thermograph4)
	(calibration_target instrument4 Star1)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon2)
)
(:goal (and
	(pointing satellite2 Phenomenon5)
	(pointing satellite3 Star4)
	(have_image Phenomenon2 spectrograph0)
	(have_image Star3 spectrograph2)
	(have_image Star4 thermograph4)
	(have_image Phenomenon5 thermograph4)
))

)
