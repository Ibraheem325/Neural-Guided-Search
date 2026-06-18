(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	thermograph4 - mode
	spectrograph1 - mode
	spectrograph0 - mode
	infrared3 - mode
	spectrograph2 - mode
	GroundStation3 - direction
	Star6 - direction
	Star10 - direction
	Star11 - direction
	Star7 - direction
	Star0 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	Star1 - direction
	Star8 - direction
	GroundStation2 - direction
	GroundStation9 - direction
	Planet12 - direction
	Planet13 - direction
	Planet14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 Star11)
	(supports instrument1 spectrograph1)
	(supports instrument1 infrared3)
	(supports instrument1 spectrograph2)
	(calibration_target instrument1 Star0)
	(supports instrument2 infrared3)
	(supports instrument2 spectrograph2)
	(calibration_target instrument2 Star1)
	(calibration_target instrument2 GroundStation5)
	(calibration_target instrument2 GroundStation4)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star11)
	(supports instrument3 thermograph4)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 Star8)
	(supports instrument4 spectrograph2)
	(supports instrument4 thermograph4)
	(supports instrument4 spectrograph0)
	(calibration_target instrument4 GroundStation2)
	(supports instrument5 spectrograph0)
	(supports instrument5 thermograph4)
	(calibration_target instrument5 GroundStation9)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star1)
)
(:goal (and
	(have_image Planet12 thermograph4)
	(have_image Planet13 spectrograph1)
	(have_image Planet14 spectrograph1)
	(have_image Planet15 spectrograph2)
))

)
